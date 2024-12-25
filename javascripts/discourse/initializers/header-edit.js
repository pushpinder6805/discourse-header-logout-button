import { withPluginApi } from "discourse/lib/plugin-api";
import { iconNode } from "discourse-common/lib/icon-library";
import I18n from "discourse-i18n";

export default {
  name: "header-logout-button",

  initialize() {
    withPluginApi("1.28.0", (api) => {
      const currentUser = api.container.lookup("service:current-user");
      if (currentUser) {
        api.decorateWidget("header-icons:after", (helper) => {
          return helper.h("li.header-logout-button", [
            helper.h(
              "button.btn.btn-icon.btn-flat.logout-button",
              {
                title: I18n.t("logout.title"),
                onclick() {
                  if (confirm(I18n.t("logout.confirm"))) {
                    fetch("/session/logout", {
                      method: "POST",
                      headers: {
                        "X-CSRF-Token": document
                          .querySelector("meta[name='csrf-token']")
                          .getAttribute("content"),
                      },
                    }).then(() => {
                      window.location.reload();
                    });
                  }
                },
              },
              iconNode("power-off")
            ),
          ]);
        });
      }
    });
  },
};
