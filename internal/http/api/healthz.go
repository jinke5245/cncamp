package api

import (
	"net/http"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
)

func Healthz(c *gin.Context) {
	// 接收客户端 request，并将 request 中带的 header 写入 response header
	for key, values := range c.Request.Header {
		for _, value := range values {
			c.Writer.Header().Add(key, value)
		}
	}
	// 读取当前系统的环境变量中的 VERSION 配置，并写入 response header
	for _, env := range os.Environ() {
		if parts := strings.SplitN(env, "=", 2); len(parts) == 2 {
			c.Header(parts[0], parts[1])
		}
	}

	// 当访问 localhost/healthz 时，应返回 200
	c.JSON(http.StatusOK, c.Writer.Header())
}
