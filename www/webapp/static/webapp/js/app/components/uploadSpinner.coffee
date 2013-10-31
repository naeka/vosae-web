###
  This component is used for ajax upload progression

  @class RoundProgressBar
  @namespace Vosae
  @module Components
###

Vosae.Components.RoundProgressBar = Em.View.extend
  template: Handlebars.compile('
    <div class="loader">
      <div class="loader-bg">
          <div class="text"></div>
      </div>        
      <div class="spiner-holder-one animate-0-25-a">
          <div class="spiner-holder-two animate-0-25-b">
              <div class="loader-spiner" style=""></div>
          </div>
      </div>
      <div class="spiner-holder-one animate-25-50-a">
          <div class="spiner-holder-two animate-25-50-b">
              <div class="loader-spiner"></div>
          </div>
      </div>
      <div class="spiner-holder-one animate-50-75-a">
          <div class="spiner-holder-two animate-50-75-b">
              <div class="loader-spiner"></div>
          </div>
      </div>
      <div class="spiner-holder-one animate-75-100-a">
          <div class="spiner-holder-two animate-75-100-b">
              <div class="loader-spiner"></div>
          </div>
      </div>
    </div>
  ')
  classNames: ["round-progress-bar", "clearfix"]
  progress: 0

  shouldBeHidden: (->
    if @get('isUploading')
      @.$().css('display', 'block')
    else
      @.$().css('display', 'none')
  ).observes 'isUploading'

  renderProgress: (->
    progress = Math.floor @get('progress')
    if progress < 25
        angle = -90 + (progress / 100) * 360
        @.$().find(".animate-0-25-b").css "transform", "rotate(#{angle}deg)"
  
    else if progress >= 25 and progress < 50
        angle = -90 + ((progress - 25) / 100) * 360
        @.$().find(".animate-0-25-b").css "transform", "rotate(0deg)"
        @.$().find(".animate-25-50-b").css "transform", "rotate(#{angle}deg)"
  
    else if progress >= 50 and progress < 75
        angle = -90 + ((progress - 50) / 100) * 360
        @.$().find(".animate-25-50-b, .animate-0-25-b").css "transform", "rotate(0deg)"
        @.$().find(".animate-50-75-b").css "transform", "rotate(#{angle}deg)"

    else if progress >= 75 and progress <= 100
        angle = -90 + ((progress - 75) / 100) * 360
        @.$().find(".animate-50-75-b, .animate-25-50-b, .animate-0-25-b").css "transform", "rotate(0deg)"
        @.$().find(".animate-75-100-b").css "transform", "rotate(#{angle}deg)"
    
    @.$().find(".text").html "#{progress}%"
  ).observes 'progress'
