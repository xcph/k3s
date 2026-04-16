//go:build ctrd

package containerd

import (
	"fmt"
	"os"
	"runtime/debug"

	"github.com/containerd/containerd/v2/cmd/containerd/command"
)

func Main() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Fprintf(os.Stderr, "containerd: panic recovered: %v\n%s\n", r, debug.Stack())
			os.Exit(2)
		}
	}()

	app := command.App()
	if err := app.Run(os.Args); err != nil {
		fmt.Fprintf(os.Stderr, "containerd: %s\n", err)
		os.Exit(1)
	}
}
