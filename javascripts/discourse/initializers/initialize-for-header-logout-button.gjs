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
    api.logout();  // Use the API method for logout
  });
}

// Ensure the icon is rendered before adding the event listener
function addLogoutButtonListener() {
  const logoutButton = document.querySelector('.btn.no-text.icon.btn-flat.header-logout');
  if (logoutButton) {
    logoutButton.addEventListener('click', logoutAction);
  } else {
    console.error("Logout button not found in the DOM.");
  }
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
        let links = settings.header_logout_button_link;

        // Filter links based on the view
        if (site.mobileView) {
          links = links.filter(link => link.view === "vmo" || link.view === "vdm");
        } else {
          links = links.filter(link => link.view === "vdo" || link.view === "vdm");
        }

        // Loop over each link and build the icon component
        links.forEach((link, index) => {
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

          // Add the logout button listener after the icon is added
          api.onPageChange(() => {
            // Timeout to ensure the DOM is updated before attaching the listener
            setTimeout(addLogoutButtonListener, 0);
          });
        });
      } catch (error) {
        console.error("Error in header icon links component", error);
      }
    });
  },
};
