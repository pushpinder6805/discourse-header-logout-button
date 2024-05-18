import { h } from "virtual-dom";
import { withPluginApi } from "discourse/lib/plugin-api";
import { iconNode } from "discourse-common/lib/icon-library";
import I18n from "discourse-i18n";

export default {
  initialize() {
    withPluginApi("0.8", (api) => {
      const currentUser = api.container.lookup("service:current-user");
        if (currentUser !== null) {
          api.addToHeaderIcons("header-logout-button");
        }
    });
  },
};
