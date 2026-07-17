package models

import "time"

// User 用户模型
type User struct {
	ID        uint       `json:"id" gorm:"primaryKey"`
	Username  string     `json:"username" gorm:"uniqueIndex;size:50;not null"`
	Email     string     `json:"email" gorm:"size:100"`
	Password  string     `json:"-" gorm:"not null"`
	Nickname  string     `json:"nickname" gorm:"size:50"`
	Avatar    string     `json:"avatar" gorm:"size:255"`
	VIPLevel  int        `json:"vip_level" gorm:"default:0"` // 0=免费, 1=基础, 2=高级
	VIPExpire *time.Time `json:"vip_expire"`
	CreatedAt time.Time  `json:"created_at"`
	UpdatedAt time.Time  `json:"updated_at"`
}

// Order 支付订单
type Order struct {
	ID            uint      `json:"id" gorm:"primaryKey"`
	UserID        uint      `json:"user_id" gorm:"index;not null"`
	OrderNo       string    `json:"order_no" gorm:"uniqueIndex;size:64;not null"`
	ProductID     string    `json:"product_id" gorm:"size:50;not null"`   // vip_monthly, vip_yearly, vip_lifetime
	ProductName   string    `json:"product_name" gorm:"size:100"`
	Amount        int       `json:"amount" gorm:"not null"`               // 金额(分)
	PayChannel    string    `json:"pay_channel" gorm:"size:20"`          // alipay, wechat, stripe
	PayStatus     int       `json:"pay_status" gorm:"default:0"`         // 0=待支付, 1=已支付, 2=已退款, 3=已关闭
	TransactionID string    `json:"transaction_id" gorm:"size:128"`      // 第三方支付流水号
	PaidAt        time.Time `json:"paid_at"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

// ---- Request/Response DTOs ----

type RegisterRequest struct {
	Username string `json:"username" binding:"required,min=3,max=50"`
	Email    string `json:"email"`
	Password string `json:"password" binding:"required,min=6,max=100"`
}

type LoginRequest struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type LoginResponse struct {
	Token  string   `json:"token"`
	User   UserInfo `json:"user"`
}

type UserInfo struct {
	ID        uint      `json:"id"`
	Username  string    `json:"username"`
	Email     string    `json:"email"`
	Nickname  string    `json:"nickname"`
	Avatar    string    `json:"avatar"`
	VIPLevel  int        `json:"vip_level"`
	VIPExpire *time.Time `json:"vip_expire"`
}

type CreateOrderRequest struct {
	ProductID  string `json:"product_id" binding:"required"`
	PayChannel string `json:"pay_channel" binding:"required,oneof=alipay wechat stripe"`
}

type CreateOrderResponse struct {
	OrderNo   string `json:"order_no"`
	Amount    int    `json:"amount"`
	PayURL    string `json:"pay_url"`    // 支付链接/二维码
	PayParams string `json:"pay_params"` // 额外支付参数(JSON)
}

type APIResponse struct {
	Code    int         `json:"code"`
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
}
