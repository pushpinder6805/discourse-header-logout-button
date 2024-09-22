import { dasherize } from "@ember/string";
import concatClass from "discourse/helpers/concat-class";
import { withPluginApi } from "discourse/lib/plugin-api";
import { escapeExpression } from "discourse/lib/utilities";
import icon from "discourse-common/helpers/d-icon";
import { apiInitializer } from "discourse/lib/api";
import User from "discourse/models/user";  // Import the User model

// Function to handle the logout action using the new API
function logoutAction() {
  withPluginApi("0.8.41", (api) => {
    if (api && typeof api.logout === "function") {
      api.logout();  // Ensure the API method for logout is valid
    } else {
      console.error("Invalid API object or logout method not found.");
    }
  });
}

// Use MutationObserver to detect when the button is added to the DOM
function observeDOMForLogoutButton() {
  const observer = new MutationObserver((mutationsList) => {
    for (const mutation of mutationsList) {
      if (mutation.type === "childList") {
        const logoutButton = document.querySelector('.btn.no-text.icon.btn-flat.header-logout');
        if (logoutButton) {
          logoutButton.addEventListener('click', logoutAction);
          observer.disconnect();  // Stop observing once the button is found and the listener is added
        }
      }
    }
  });

  // Start observing the body for added nodes (i.e., DOM changes)
  observer.observe(document.body, { childList: true, subtree: true });
}

function buildIcon(iconNameOrImageUrl, title) {
  return `<template>{{icon "${iconNameOrImageUrl}" label="${title}"}}</template>`;
}

export default {
  name: "header-logout-button",
  initialize() {
    withPluginApi("0.8.41", (api) => {
      try {
        const site = api.container.lookup("service:site");
        
        if (!site) {
          console.error("Site object not found.");
          return;
        }

        let links = settings.header_logout_button_link;

        // Ensure `links` is an array and filter based on the view
        if (Array.isArray(links)) {
          if (site.mobileView) {
            links = links.filter(link => link.view === "vmo" || link.view === "vdm");
          } else {
            links = links.filter(link => link.view === "vdo" || link.view === "vdm");
          }
        } else {
          console.error("Invalid `links` settings.");
          return;
        }

        // Loop over each link and build the icon component
        links.forEach((link, index) => {
          if (link && typeof link === "object") {
            const iconTemplate = buildIcon(link.icon, link.title);
            const className = `header-icon-${dasherize(link.title)}`;
            const target = link.target === "blank" ? "_blank" : "";
            const rel = link.target ? "noopener" : "";
            const isLastLink = index === links.length - 1 ? "last-custom-icon" : "";

            let style = "";
            if (link.width) {
              style = `width: ${escapeExpression(link.width)}px`;
            }

            const iconComponent = `
              <li class="${concatClass('custom-header-logout-button', className, link.view, isLastLink)}">
                <a
                  class="btn no-text icon btn-flat header-logout"
                  href="#"
                  title="${link.title}"
                  target="${target}"
                  rel="${rel}"
                  style="${style}"
                >
                  ${iconTemplate}
                </a>
              </li>
            `;

            const beforeIcon = ["chat", "search", "hamburger", "user-menu"];

            api.headerIcons.add(link.title, iconComponent, { before: beforeIcon });

            // Use MutationObserver to watch for the logout button being added to the DOM
            api.onPageChange(() => {
              observeDOMForLogoutButton();
            });
          } else {
            console.error("Invalid link object.");
          }
        });
      } catch (error) {
        console.error("Error in header icon links component", error);
      }
    });
  },
};
