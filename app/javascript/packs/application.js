// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
/*global $*/

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

Rails.start();
Turbolinks.start();
ActiveStorage.start();

import 'bootstrap/dist/js/bootstrap';
import 'bootstrap/dist/css/bootstrap';
import "stylesheets/application";
import "@fortawesome/fontawesome-free/css/all";
import "chartkick/chart.js";

require('stylesheets/application.scss');
require("trix");
require("@rails/actiontext");
require("jquery-ui-dist/jquery-ui"); // yarn add jquery-ui-dist 
require("selectize");

import videojs from 'video.js';
import 'video.js/dist/video-js.css';

import "youtube";
import "cocoon-js";

// import "../trix-editor-overrides"
// Jquery ui sorting
$(document).on('turbolinks:load', function(){
  if ($('.selectize')){
      $('.selectize').selectize({
          sortField: 'text'
      });
  };
  
  $(".selectize-tags").selectize({
    create: function(input, callback) {
      $.post('/tags.json', { tag: { name: input } })
        .done(function(response){
          console.log(response)
          callback({value: response.id, text: response.name });
        })
    }
  });
  
  $('.lesson-sortable').sortable({
    cursor: "grabbing",
    cursorAt: { left: 10 },
    placeholder: "ui-state-highlight",
    update: function(e, ui){
      let item = ui.item;
      let item_data = item.data();
      let params = {_method: 'put'};
      params[item_data.modelName] = { row_order_position: item.index() };
      $.ajax({
        type: 'POST',
        url: item_data.updateUrl,
        dataType: 'json',
        data: params
      });
    },
    stop: function(e, ui){
      console.log("stop called when finishing sort of cards");
    }
  });
  
  $("video").bind("contextmenu",function(){
      return false;
  });
  
  let videoPlayer = videojs(document.getElementById('my-video'), {
    controls: true,
    playbackRates: [0.5, 1, 1.5],
    autoplay: false,
    fluid: true,
    preload: false,
    liveui: true,
    responsive: true,
    loop: false,
  });
  videoPlayer.addClass('video-js');
  videoPlayer.addClass('vjs-big-play-centered');
  
  
});

