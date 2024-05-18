import { hbs } from "ember-cli-htmlbars";
import RenderGlimmer from "discourse/widgets/render-glimmer";
import { createWidget } from "discourse/widgets/widget";

export default createWidget("header-logout-button", {
  tagName: "btn.btn-icon-text.btn-primary.btn-small.header-logout-button",

  html() {
    return [new RenderGlimmer(this, "div", hbs`<HeaderLogoutButton />`)];
  },
});
