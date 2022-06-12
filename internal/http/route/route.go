package route

import (
	"fmt"
	"cncamp/internal/http/api"
	"time"

	"github.com/gin-gonic/gin"
)

func Route(r *gin.Engine) *gin.Engine {
	// Server 端记录访问日志包括客户端 IP，HTTP 返回码，输出到 server 端的标准输出
	r.Use(gin.LoggerWithFormatter(func(param gin.LogFormatterParams) string {
		return fmt.Sprintf("[%s] host=%s method=%s path=%s status=%d",
			param.TimeStamp.Format(time.RFC3339),
			param.ClientIP,
			param.Method,
			param.Path,
			param.StatusCode,
		)
	}))
	r.GET("/healthz", api.Healthz)
	return r
}
