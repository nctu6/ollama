//go:build !windows && !darwin

package cmd

import (
	"context"
	"errors"

	"github.com/nctu6/unieai/api"
)

func startApp(ctx context.Context, client *api.Client) error {
	return errors.New("could not connect to unieai server, run 'unieai serve' to start it")
}
