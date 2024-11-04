// Package errtypes contains custom error types
package errtypes

import (
	"fmt"
	"strings"
)

const (
	UnknownUnieaiKeyErrMsg = "unknown unieai key"
	InvalidModelNameErrMsg = "invalid model name"
)

// TODO: This should have a structured response from the API
type UnknownUnieaiKey struct {
	Key string
}

func (e *UnknownUnieaiKey) Error() string {
	return fmt.Sprintf("unauthorized: %s %q", UnknownUnieaiKeyErrMsg, strings.TrimSpace(e.Key))
}
