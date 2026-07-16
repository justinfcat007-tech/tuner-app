package models

import (
	"fmt"
	"log"
	"tuner-app/backend/config"

	"gorm.io/driver/mysql"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

func InitDB(cfg *config.Config) *gorm.DB {
	var db *gorm.DB
	var err error

	if cfg.DBPass == "" {
		// 无密码时使用 SQLite 作为开发数据库
		db, err = gorm.Open(sqlite.Open("tuner.db"), &gorm.Config{})
		if err != nil {
			log.Fatalf("SQLite连接失败: %v", err)
		}
		log.Println("使用 SQLite 开发数据库")
	} else {
		dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
			cfg.DBUser, cfg.DBPass, cfg.DBHost, cfg.DBPort, cfg.DBName)
		db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
		if err != nil {
			log.Fatalf("MySQL连接失败: %v", err)
		}
		log.Println("已连接 MySQL")
	}

	// 自动迁移
	db.AutoMigrate(&User{}, &Order{})

	return db
}
