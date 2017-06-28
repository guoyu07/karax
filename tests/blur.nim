import vdom, kdom, vstyles, karax, karaxdsl, jdict, jstrutils

type TextInput* = ref object of VComponent
  value: cstring
  isActive: bool

proc render(x: VComponent): VNode =
  let self = TextInput(x)

  let style = style(
    (StyleAttr.position, cstring"relative"),
    (StyleAttr.paddingLeft, cstring"10px"),
    (StyleAttr.paddingRight, cstring"5px"),
    (StyleAttr.height, cstring"30px"),
    (StyleAttr.lineHeight, cstring"30px"),
    (StyleAttr.border, cstring"solid 1px " & (if self.isActive: cstring"red" else: cstring"black")),
    (StyleAttr.fontSize, cstring"12px"),
    (StyleAttr.fontWeight, cstring"600")
  ).merge(self.style)

  let inputStyle = style.merge(style(
    (StyleAttr.color, cstring"inherit"),
    (StyleAttr.fontSize, cstring"inherit"),
    (StyleAttr.fontWeight, cstring"inherit"),
    (StyleAttr.fontFamily, cstring"inherit"),
    (StyleAttr.position, cstring"absolute"),
    (StyleAttr.top, cstring"0"),
    (StyleAttr.left, cstring"0"),
    (StyleAttr.height, cstring"100%"),
    (StyleAttr.width, cstring"100%"),
    (StyleAttr.border, cstring"none"),
    (StyleAttr.backgroundColor, cstring"transparent"),
  ))

  proc flip(ev: Event; n: VNode) =
    self.isActive = not self.isActive
    kout cstring"onflip", n.value
    markDirty(self)

  proc onchanged(ev: Event; n: VNode) =
    kout cstring"onchanged", n.value

  result = buildHtml(tdiv(style=style)):
    input(style=inputStyle, value=self.value, onblur=flip, onfocus=flip, onkeyup=onchanged)

proc newTextInput*(style: VStyle = VStyle(); value: cstring = cstring""): TextInput =
  result = newComponent(TextInput, render)
  result.style = style
  result.value = value

type
  Combined = ref object of VComponent
    a, b: TextInput

proc renderComb(self: VComponent): VNode =
  let self = Combined(self)
  result = buildHtml(tdiv(style=self.style)):
    self.a
    self.b

proc newCombined*(style: VStyle = VStyle()): Combined =
  result = newComponent(Combined, renderComb)
  result.a = newTextInput(style, "AAA")
  result.b = newTextInput(style, "BBB")

proc createDom(): VNode =
  result = buildHtml(tdiv):
    newCombined()

setRenderer createDom
