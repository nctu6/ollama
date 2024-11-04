package cmd

import (
	"context"
	"errors"
	"os"
	"os/exec"
	"strings"

	"github.com/nctu6/unieai/api"
)

func startApp(ctx context.Context, client *api.Client) error {
	exe, err := os.Executable()
	if err != nil {
		return err
	}
	link, err := os.Readlink(exe)
	if err != nil {
		return err
	}
	if !strings.Contains(link, "Unieai.app") {
		return errors.New("could not find unieai app")
	}
	path := strings.Split(link, "Unieai.app")
	if err := exec.Command("/usr/bin/open", "-a", path[0]+"Unieai.app").Run(); err != nil {
		return err
	}
	return waitForServer(ctx, client)
}
