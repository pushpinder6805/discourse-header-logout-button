import { hbs } from "ember-cli-htmlbars";
import RenderGlimmer from "discourse/widgets/render-glimmer";
import { createWidget } from "discourse/widgets/widget";

export default createWidget("header-logout-button", {
  tagName: "li.header-logout-button",

  html() {
    return [new RenderGlimmer(this, "div", hbs`<HeaderLogoutButton />`)];
  },
});
