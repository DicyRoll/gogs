package {{.Package}}

import (
	"context"
	"reflect"

	"github.com/metagogs/gogs"
	"github.com/metagogs/gogs/component"
	"github.com/metagogs/gogs/packet"
	"github.com/metagogs/gogs/session"
)

func RegisterAllComponents(s *gogs.App, srv Component) {
    {{range .Components}} register{{.Name}}Component(s, srv)
    {{end}}
}

{{range .Components}}
func register{{.Name}}Component(s *gogs.App, srv Component) {
	s.RegisterComponent(_{{.Name}}ComponentDesc, srv)
}
{{end}}

type Component interface {
{{range .Components}}{{range .Fields}}
	{{if not .ServerMessage}}{{.Name}}(ctx context.Context, s *session.Session, in *{{.Name}})
	{{end}}
{{end}}{{end}}
}

{{range .Components}}{{range .Fields}}
{{if not .ServerMessage}}
func _{{.ComponentName}}Component_{{.Name}}_Handler(srv interface{}, ctx context.Context, sess *session.Session, in interface{}) {
	srv.(Component).{{.Name}}(ctx, sess, in.(*{{.Name}}))
}
{{end}}
{{end}}{{end}}

{{range .Components}}
var _{{.Name}}ComponentDesc = component.ComponentDesc{
	ComonentName:   "{{.Name}}Component",
	ComponentIndex: {{.Index}}, // equeal to module index
	ComponentType:  (*Component)(nil),
	Methods: []component.ComponentMethodDesc{
		{{range .Fields}}{
			MethodIndex: packet.CreateAction(packet.ServicePacket, {{.ComponentIndex}}, {{.Index}}),
			FieldType:   reflect.TypeOf({{.Name}}{}),
			{{if .ServerMessage}}Handler:     nil,{{else}}Handler:     _{{.ComponentName}}Component_{{.Name}}_Handler,{{end}}
			FiledHanler: func() interface{} {
				return new({{.Name}})
			},
		},
		{{end}}
	},
}
{{end}}
