package http

import (
	"cncamp/internal/http/route"

	"github.com/gin-gonic/gin"
)

type Application struct {
	s *gin.Engine
}

func New() *Application {
	return &Application{route.Route(gin.New())}
}

func (app *Application) Listen(addr string) error {
	return app.s.Run(addr)
}
