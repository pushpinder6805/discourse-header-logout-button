import { dasherize } from "@ember/string";
import concatClass from "discourse/helpers/concat-class";
import { withPluginApi } from "discourse/lib/plugin-api";
import { escapeExpression } from "discourse/lib/utilities";
import icon from "discourse-common/helpers/d-icon";
// import isValidUrl from "../lib/isValidUrl";
import { apiInitializer } from "discourse/lib/api";

function logoutAction() {
  // Trigger logout logic
  Discourse.User.current().logout();
}


function buildIcon(iconNameOrImageUrl, title) {
    return <template>{{icon iconNameOrImageUrl label=title}}</template>;
}

export default {
  name: "header-logout-button",
  initialize() {
    withPluginApi("0.8.41", (api) => {
      try {
        const site = api.container.lookup("service:site");
        let links = settings.header_logout_button_link;
        if (site.mobileView) {
          links = links.filter(
            (link) => link.view === "vmo" || link.view === "vdm"
          );
        } else {
          links = links.filter(
            (link) => link.view === "vdo" || link.view === "vdm"
          );
        }

        links.forEach((link, index) => {
          const iconTemplate = buildIcon(link.icon, link.title);
          const className = `header-icon-${dasherize(link.title)}`;
          const target = link.target === "blank" ? "_blank" : "";
          const rel = link.target ? "noopener" : "";
          const isLastLink =
            index === links.length - 1 ? "last-custom-icon" : "";

          let style = "";
          if (link.width) {
            style = `width: ${escapeExpression(link.width)}px`;
          }

          const iconComponent = <template>
            <li
              class={{concatClass
                "custom-header-logout-button"
                className
                link.view
                isLastLink
              }}
            >
              <a
                class="btn no-text icon btn-flat"
                href={{link.url}}
                title={{link.title}}
                target={{target}}
                rel={{rel}}
                style={{style}}
              >
                {{iconTemplate}}
              </a>
            </li>

    <li class="custom-header-logout-button">
      <a class="btn no-text icon btn-flat header-logout" href="#" title="Logout">
        HELLO{{iconTemplate}}
      </a>
    </li>
          </template>;


          const beforeIcon = ["chat", "search", "hamburger", "user-menu"];

  api.onPageChange(() => {
    document.querySelector('.btn.no-text.icon.btn-flat.header-logout').addEventListener('click', logoutAction);
  });

          api.headerIcons.add(link.title, iconComponent, {
            before: beforeIcon,
          });
        });
      } catch (error) {
        // eslint-disable-next-line no-console
        console.error(
          error,
          "There's an issue in the header icon links component. Check if your settings are entered correctly"
        );
      }
    });
  },
};

