package main

import (
	"context"

	"github.com/spf13/cobra"

	"github.com/nctu6/unieai/cmd"
)

func main() {
	cobra.CheckErr(cmd.NewCLI().ExecuteContext(context.Background()))
}
