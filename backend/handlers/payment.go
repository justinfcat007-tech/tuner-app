package handlers

import (
	"fmt"
	"math/rand"
	"net/http"
	"time"
	"tuner-app/backend/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type PaymentHandler struct {
	DB *gorm.DB
}

func NewPaymentHandler(db *gorm.DB) *PaymentHandler {
	return &PaymentHandler{DB: db}
}

// 商品定义
type Product struct {
	ID        string `json:"id"`
	Name      string `json:"name"`
	Amount    int    `json:"amount"`    // 金额(分)
	VIPLevel  int    `json:"vip_level"` // 1=基础VIP, 2=高级VIP
	VIPDays   int    `json:"vip_days"`  // 0=永久
}

var products = map[string]Product{
	"vip_monthly":  {ID: "vip_monthly", Name: "基础VIP - 月卡", Amount: 1900, VIPLevel: 1, VIPDays: 30},
	"vip_quarterly": {ID: "vip_quarterly", Name: "基础VIP - 季卡", Amount: 4900, VIPLevel: 1, VIPDays: 90},
	"vip_yearly":   {ID: "vip_yearly", Name: "高级VIP - 年卡", Amount: 9900, VIPLevel: 2, VIPDays: 365},
	"vip_lifetime": {ID: "vip_lifetime", Name: "高级VIP - 终身", Amount: 29900, VIPLevel: 2, VIPDays: 0},
}

// GetProducts 获取商品列表
func (h *PaymentHandler) GetProducts(c *gin.Context) {
	list := make([]Product, 0, len(products))
	for _, p := range products {
		list = append(list, p)
	}
	c.JSON(http.StatusOK, models.APIResponse{Code: 0, Data: list})
}

// CreateOrder 创建支付订单
func (h *PaymentHandler) CreateOrder(c *gin.Context) {
	var req models.CreateOrderRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{Code: 400, Message: "参数错误"})
		return
	}

	product, exists := products[req.ProductID]
	if !exists {
		c.JSON(http.StatusBadRequest, models.APIResponse{Code: 400, Message: "商品不存在"})
		return
	}

	userID, _ := c.Get("user_id")

	// 生成订单号: 时间戳 + 随机数
	orderNo := fmt.Sprintf("TN%s%04d", time.Now().Format("20060102150405"), rand.Intn(10000))

	order := models.Order{
		UserID:      userID.(uint),
		OrderNo:     orderNo,
		ProductID:   product.ID,
		ProductName: product.Name,
		Amount:      product.Amount,
		PayChannel:  req.PayChannel,
		PayStatus:   0, // 待支付
	}

	if err := h.DB.Create(&order).Error; err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{Code: 500, Message: "创建订单失败"})
		return
	}

	// 模拟生成支付链接/参数
	payURL := generatePayURL(req.PayChannel, orderNo, product.Amount)

	c.JSON(http.StatusOK, models.APIResponse{
		Code:    0,
		Message: "订单创建成功",
		Data: models.CreateOrderResponse{
			OrderNo: orderNo,
			Amount:  product.Amount,
			PayURL:  payURL,
		},
	})
}

// OrderList 用户订单列表
func (h *PaymentHandler) OrderList(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var orders []models.Order
	h.DB.Where("user_id = ?", userID).Order("created_at DESC").Limit(50).Find(&orders)

	c.JSON(http.StatusOK, models.APIResponse{Code: 0, Data: orders})
}

// PayCallback 支付回调 (模拟)
// 实际生产中需对接支付宝/微信支付的回调验签
func (h *PaymentHandler) PayCallback(c *gin.Context) {
	orderNo := c.Query("order_no")
	if orderNo == "" {
		c.JSON(http.StatusBadRequest, models.APIResponse{Code: 400, Message: "缺少order_no"})
		return
	}

	var order models.Order
	if err := h.DB.Where("order_no = ?", orderNo).First(&order).Error; err != nil {
		c.JSON(http.StatusNotFound, models.APIResponse{Code: 404, Message: "订单不存在"})
		return
	}

	if order.PayStatus != 0 {
		c.JSON(http.StatusOK, models.APIResponse{Code: 0, Message: "订单已处理"})
		return
	}

	// 更新订单状态
	product := products[order.ProductID]
	now := time.Now()
	order.PayStatus = 1
	order.PaidAt = now
	order.TransactionID = fmt.Sprintf("MOCK_%s_%d", order.OrderNo, now.Unix())
	h.DB.Save(&order)

	// 更新用户VIP
	var user models.User
	h.DB.First(&user, order.UserID)

	var expireTime time.Time
	if user.VIPExpire != nil && user.VIPExpire.After(now) {
		expireTime = *user.VIPExpire
	} else {
		expireTime = now
	}

	if product.VIPDays == 0 {
		// 永久VIP: 设置为99年后
		expireTime = now.Add(99 * 365 * 24 * time.Hour)
	} else {
		expireTime = expireTime.Add(time.Duration(product.VIPDays) * 24 * time.Hour)
	}

	user.VIPLevel = product.VIPLevel
	user.VIPExpire = &expireTime
	h.DB.Save(&user)

	c.JSON(http.StatusOK, models.APIResponse{Code: 0, Message: "支付成功"})
}

func generatePayURL(channel, orderNo string, amount int) string {
	switch channel {
	case "alipay":
		return fmt.Sprintf("https://openapi.alipay.com/gateway.do?out_trade_no=%s&total_amount=%d", orderNo, amount)
	case "wechat":
		return fmt.Sprintf("weixin://wxpay/bizpayurl?order_no=%s&amount=%d", orderNo, amount)
	case "stripe":
		return fmt.Sprintf("https://checkout.stripe.com/pay/cs_test_%s", orderNo)
	default:
		return ""
	}
}
