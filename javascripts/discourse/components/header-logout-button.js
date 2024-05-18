import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";

export default class HeaderLogoutButton extends Component {
  @service currentUser;
  @tracked isActive = false;

  constructor() {
    super(...arguments);
    this.handleDocumentClick = this.handleDocumentClick.bind(this);
  }


  

  handleDocumentClick(event) {
    const dropdown = document.querySelector(".header-user-new__menu");
    const isClickInside = dropdown.contains(event.target);

    if (!isClickInside) {
      this.isActive = false;
      document.removeEventListener("click", this.handleDocumentClick);
    }
  }


}
