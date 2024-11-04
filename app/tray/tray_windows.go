package tray

import (
	"github.com/nctu6/unieai/app/tray/commontray"
	"github.com/nctu6/unieai/app/tray/wintray"
)

func InitPlatformTray(icon, updateIcon []byte) (commontray.UnieaiTray, error) {
	return wintray.InitTray(icon, updateIcon)
}
