package main

import (
	"cncamp/internal/http"
	"log"
	"os"

	"github.com/spf13/cobra"
)

var rootCommand = &cobra.Command{
	Use: os.Args[0],
	Run: func(cmd *cobra.Command, args []string) {
		if err := http.New().Listen(":80"); err != nil {
			log.Fatal(err)
		}
	},
}

func main() {
	rootCommand.Execute()
}
