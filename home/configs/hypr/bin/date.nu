def html [tag:string attrs?:record = {}]: [
  nothing -> string
  string -> string
] {

  let $enc_attrs = match $attrs {
    {} => ""
    _ => ($attrs
      | items { |k, v|
        $'($k)="($v | into string)"'
      }
      | reduce { |it, acc| $'($it) ($acc)' })
  }

  match ($in | describe) {
    "nothing" => $'<($tag) ($enc_attrs)/>'
    "string" => $'<($tag) ($enc_attrs)>($in)</($tag)>'
  }
}

def main []: nothing -> nothing {}

def "main clock" []: nothing -> string {
  date now | format date "%I:%M %p" | html "u"
}

def "main date" []: nothing -> string {
  date now | format date "%A (%d) %B %Y"
}
