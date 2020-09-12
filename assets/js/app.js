import "../css/spectre.scss"

import "phoenix_html"
import {Socket} from "phoenix"
import NProgress from "nprogress"
import {LiveSocket} from "phoenix_live_view"
import { Sortable } from "@shopify/draggable";

const Hooks = {}
Hooks.Draggable = {
  mounted() {
    this.initDraggable();
  },
  updated() {
    this.sortable.destroy()
    this.initDraggable()
  },
  initDraggable() {
    this.sortable = new Sortable(document.querySelectorAll(".draggable"), {
      draggable: ".tile",
      mirror: {
        constrainDimensions: true
      }
    })
    this.sortable.on("sortable:stop", (e) => console.log(e.data.newContainer.getAttribute("data-day")))
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})

window.addEventListener("phx:page-loading-start", _info => NProgress.start())
window.addEventListener("phx:page-loading-stop", _info => NProgress.done())

liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket
