(
    "logout-button",
    <template>
      <li>
        <a id="logout-button" class="icon" href="#" onclick={{logoutAction}} title="Logout">
          {{dIcon "sign-out-alt"}}
        </a>
      </li>
    </template>,
    { before: "search" }  // Adjust this placement as needed
  );
