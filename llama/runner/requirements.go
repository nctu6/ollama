package main

import (
	"encoding/json"
	"os"

	"github.com/nctu6/unieai/llama"
	"github.com/nctu6/unieai/version"
)

func printRequirements(fp *os.File) {
	attrs := map[string]string{
		"system_info":  llama.PrintSystemInfo(),
		"version":      version.Version,
		"cpu_features": llama.CpuFeatures,
	}
	enc := json.NewEncoder(fp)
	_ = enc.Encode(attrs)
}
