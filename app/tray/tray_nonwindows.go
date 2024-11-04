//go:build !windows

package tray

import (
	"errors"

	"github.com/nctu6/unieai/app/tray/commontray"
)

func InitPlatformTray(icon, updateIcon []byte) (commontray.UnieaiTray, error) {
	return nil, errors.New("not implemented")
}
