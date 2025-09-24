#!/usr/bin/env nu

def main [] {
  let info = niri msg -j focused-window | from json

  if info.pid != null {
    kill -f $info.pid
  }
}
