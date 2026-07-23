package config

import (
	"log"
	"os"
	"strings"

	"github.com/joho/godotenv"
)

type Config struct {
	Port            string
	DBHost          string
	DBPort          string
	DBUser          string
	DBPass          string
	DBName          string
	JWTSecret       string
	CORSOrigins     []string
	PaymentsEnabled bool
}

func Load() *Config {
	if err := godotenv.Load(); err != nil {
		log.Println("未找到 .env 文件，使用系统环境变量")
	}
	return &Config{
		Port:            getEnv("PORT", "8080"),
		DBHost:          getEnv("DB_HOST", "127.0.0.1"),
		DBPort:          getEnv("DB_PORT", "3306"),
		DBUser:          getEnv("DB_USER", "root"),
		DBPass:          getRequiredEnv("DB_PASS"),
		DBName:          getEnv("DB_NAME", "tuner_app"),
		JWTSecret:       getRequiredEnv("JWT_SECRET"),
		CORSOrigins:     splitCSV(getEnv("CORS_ORIGINS", "http://localhost,capacitor://localhost")),
		PaymentsEnabled: getEnv("PAYMENTS_ENABLED", "false") == "true",
	}
}

func getRequiredEnv(key string) string {
	value := os.Getenv(key)
	if value == "" {
		log.Fatalf("required environment variable %s is not set", key)
	}
	return value
}

func splitCSV(value string) []string {
	parts := strings.Split(value, ",")
	result := make([]string, 0, len(parts))
	for _, part := range parts {
		if trimmed := strings.TrimSpace(part); trimmed != "" {
			result = append(result, trimmed)
		}
	}
	return result
}

func getEnv(key, fallback string) string {
	if val := os.Getenv(key); val != "" {
		return val
	}
	return fallback
}
