package commontray

var (
	Title   = "Unieai"
	ToolTip = "Unieai"

	UpdateIconName = "tray_upgrade"
	IconName       = "tray"
)

type Callbacks struct {
	Quit       chan struct{}
	Update     chan struct{}
	DoFirstUse chan struct{}
	ShowLogs   chan struct{}
}

type UnieaiTray interface {
	GetCallbacks() Callbacks
	Run()
	UpdateAvailable(ver string) error
	DisplayFirstUseNotification() error
	Quit()
}
