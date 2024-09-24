// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
//ver4.6.2
import "../stylesheets/application";

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// app/javascript/packs/application.js
$(document).on('ajax:success', '.follow_btn', function(event, data) {
  // フォロー数を更新
  $('.followings_count_value').text(data.followings_count);
  $('.followers_count_value').text(data.followers_count);
}).on('ajax:error', function(event, xhr) {
  // エラーハンドリング
  console.error("Error:", xhr);
});