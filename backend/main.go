package main

import (
	"fmt"
	"log"
	"tuner-app/backend/config"
	"tuner-app/backend/handlers"
	"tuner-app/backend/middleware"
	"tuner-app/backend/models"

	"github.com/gin-gonic/gin"
)

func main() {
	cfg := config.Load()

	// 初始化数据库
	db := models.InitDB(cfg)

	// 创建 Gin 引擎
	r := gin.Default()
	r.Use(middleware.CORSMiddleware(cfg.CORSOrigins))

	// Handlers
	authH := handlers.NewAuthHandler(db)
	payH := handlers.NewPaymentHandler(db, cfg.PaymentsEnabled)

	// ===== 公开路由 =====
	api := r.Group("/api")
	{
		api.POST("/register", authH.Register)
		api.POST("/login", authH.Login)

		// 支付回调 (不需要鉴权，由第三方服务调用)
		api.GET("/payment/callback", payH.PayCallback)
		api.POST("/payment/callback", payH.PayCallback)
	}

	// ===== 需要登录的路由 =====
	auth := r.Group("/api", middleware.AuthRequired())
	{
		auth.GET("/profile", authH.Profile)

		// 支付
		auth.GET("/products", payH.GetProducts)
		auth.POST("/order/create", payH.CreateOrder)
		auth.GET("/orders", payH.OrderList)
	}

	// 健康检查
	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})

	addr := fmt.Sprintf(":%s", cfg.Port)
	log.Printf("🎶 Tuner Backend 启动于 %s", addr)
	r.Run(addr)
}
