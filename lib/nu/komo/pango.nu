def getType []: any -> string {
  $in | describe | str replace --regex '<.*' ''
}

def defaultRes [res: record] {
  match ($in | getType) {
    "nothing" => [$res]
    _ => [...$in $res]
  }
}

export def span [text: string] {
  $in
  | reduce {|it, acc| $it | merge $acc}
  | items {|attr, value|
    $"($attr)=\"($value)\""
  }
  | str join " "
  | do {
    $"<span ($in)>($text)</span>"
  }
}

export def "span font" [desc: string] {
  defaultRes { font: $desc }
}

export def "span face" [family: string] {
  defaultRes { face: $family }
}

export def "span size" [size: any] {
  defaultRes { size: ($size | into string) }
}

export def "span style" [style: string] {
  defaultRes { style: $style }
}

export def "span weight" [weight: any] {
  defaultRes { weight: ($weight | into string) }
}

export def "span variant" [variant: string] {
  defaultRes { variant: $variant }
}

export def "span stretch" [stretch: string] {
  defaultRes { stretch: $stretch }
}

export def "span features" [features: list<string>] {
  defaultRes { font_features: ($features | str join ",") }
}

export def "span fgColor" [color: string] {
  defaultRes { color: $color }
}

export def "span bgColor" [color: string] {
  defaultRes { bgcolor: $color }
}

export def "span fgAlpha" [n: any] {
  defaultRes { alpha: ($n | into string) }
}

export def "span bgAlpha" [n: any] {
  defaultRes { bgalpha: ($n | into string) }
}

export def "span underline" [type?: any = true] {
  defaultRes {
    underline:
      (match ($type | getType) {
        "string" => $type
        "bool" => (if $type { "single" } else "none")
      })
  }
}

export def "span underlineColor" [color: string] {
  defaultRes { underline_color: $color }
}

export def "span overline" [type?: bool = true] {
  defaultRes { overline: (if ($type) { "single" } else "none") }
}

export def "span overlineColor" [color: string] {
  defaultRes { overline_color: $color }
}

export def "span rise" [n: any] {
  defaultRes { rise: ($n | into string) }
}

export def "span baselineShift" [n: any] {
  defaultRes { baseline_shift: ($n | into string) }
}

export def "span scale" [scale: string] {
  defaultRes { font_scale: $scale }
}

export def "span strikethrough" [type?: bool = true] {
  defaultRes { strikethrough: ($type | into string) }
}

export def "span strikethroughColor" [color: string] {
  defaultRes { strikethrough_color: $color }
}

export def "span fallback" [enable?: bool = true] {
  defaultRes { fallback: ($enable | into string) }
}

export def "span lang" [lang: string] {
  defaultRes { lang: $lang }
}

export def "span letterSpacing" [n: float] {
  defaultRes { letter_spacing: ($n | into string) }
}

export def "span gravity" [direction: string] {
  defaultRes { gravity: $direction }
}

export def "span gravityHint" [hint: string] {
  defaultRes { gravity_hint: $hint }
}

export def "span show" [special: string] {
  defaultRes { show: $special }
}

export def "span allowBreaks" [type?: bool = true] {
  defaultRes { allow_breaks: ($type | into string) }
}

export def "span insertHypens" [type?: bool = true] {
  defaultRes { insert_hypens: ($type | into string) }
}

export def "span lineHeight" [n: any] {
  defaultRes { line_height: ($n | into string) }
}

export def "span textTransform" [type: string] {
  defaultRes { text_transform: $type }
}

export def "span segment" [type: string] {
  defaultRes { segment: $type }
}
