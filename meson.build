###############################################################################
## Project Options
###############################################################################

project('voai', 'vala', 'c')
namespace = 'voai'
version = '1.0'
description = 'An OpenAI API client library'

dependencies = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('libsoup-3.0'),
  dependency('json-glib-1.0')
  ]

sources = files(
  'chat_completion.vala',
  'completion_response.vala'
  )


###############################################################################
## probably don't need to edit below this line
###############################################################################
gnome = import('gnome')
pkg = import('pkgconfig')

add_global_arguments(['-fPIC'], language: 'c')

header = namespace.to_lower() + '.h'
vapi = namespace.to_lower() + '-' + version + '.vapi'
girfile = namespace + '-' + version + '.gir'
typelib = namespace + '-' + version + '.typelib'

lib = shared_library(namespace.to_lower(), sources,
  vala_header: header,
  vala_vapi: vapi,
  vala_gir: girfile,
  dependencies: dependencies,
  install: true,
  install_dir: [true, true, true, true])

pkg.generate(lib,
  version: version,
  name: namespace.to_lower(),
  filebase: namespace.to_lower() + '-' + version,
  description: description,
  subdirs: namespace.to_lower() + '-' + version
  )



g_ir_compiler = find_program('g-ir-compiler')
system = build_machine.system()

so = 'lib' + namespace.to_lower() + '.'
if system == 'windows'
  so += 'dll'
else
  so += 'so'
endif

custom_target('typelib', 
  command: [ g_ir_compiler, '--shared-library', meson.current_build_dir() / so, '--output', '@OUTPUT@', meson.current_build_dir() / girfile],
  output: typelib,
  depends: lib,
  install: true,
  install_dir: get_option('libdir') / 'girepository-1.0')

