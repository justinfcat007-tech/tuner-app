package handlers

import (
	"net/http"
	"tuner-app/backend/models"
	"tuner-app/backend/utils"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type AuthHandler struct {
	DB *gorm.DB
}

func NewAuthHandler(db *gorm.DB) *AuthHandler {
	return &AuthHandler{DB: db}
}

// Register 用户注册
func (h *AuthHandler) Register(c *gin.Context) {
	var req models.RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{Code: 400, Message: "参数错误: " + err.Error()})
		return
	}

	// 检查用户名是否已存在
	var count int64
	h.DB.Model(&models.User{}).Where("username = ? OR email = ?", req.Username, req.Email).Count(&count)
	if count > 0 {
		c.JSON(http.StatusConflict, models.APIResponse{Code: 409, Message: "用户名或邮箱已存在"})
		return
	}

	// 密码加密
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{Code: 500, Message: "密码加密失败"})
		return
	}

	user := models.User{
		Username: req.Username,
		Email:    req.Email,
		Password: string(hashedPassword),
		Nickname: req.Username,
	}

	if err := h.DB.Create(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{Code: 500, Message: "注册失败"})
		return
	}

	// 生成 token
	token, _ := utils.GenerateToken(user.ID, user.Username)

	c.JSON(http.StatusOK, models.APIResponse{
		Code:    0,
		Message: "注册成功",
		Data: models.LoginResponse{
			Token: token,
			User: models.UserInfo{
				ID:       user.ID,
				Username: user.Username,
				Email:    user.Email,
				Nickname: user.Nickname,
			},
		},
	})
}

// Login 用户登录
func (h *AuthHandler) Login(c *gin.Context) {
	var req models.LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{Code: 400, Message: "参数错误"})
		return
	}

	var user models.User
	if err := h.DB.Where("username = ? OR email = ?", req.Username, req.Username).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, models.APIResponse{Code: 401, Message: "用户名或密码错误"})
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, models.APIResponse{Code: 401, Message: "用户名或密码错误"})
		return
	}

	token, _ := utils.GenerateToken(user.ID, user.Username)

	c.JSON(http.StatusOK, models.APIResponse{
		Code:    0,
		Message: "登录成功",
		Data: models.LoginResponse{
			Token: token,
			User: models.UserInfo{
				ID:        user.ID,
				Username:  user.Username,
				Email:     user.Email,
				Nickname:  user.Nickname,
				Avatar:    user.Avatar,
				VIPLevel:  user.VIPLevel,
				VIPExpire: user.VIPExpire,
			},
		},
	})
}

// Profile 获取当前用户信息
func (h *AuthHandler) Profile(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var user models.User
	if err := h.DB.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, models.APIResponse{Code: 404, Message: "用户不存在"})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Code: 0,
		Data: models.UserInfo{
			ID:        user.ID,
			Username:  user.Username,
			Email:     user.Email,
			Nickname:  user.Nickname,
			Avatar:    user.Avatar,
			VIPLevel:  user.VIPLevel,
			VIPExpire: user.VIPExpire,
		},
	})
}
