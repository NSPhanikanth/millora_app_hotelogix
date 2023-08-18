// Entry point for the build script in your package.json
// import "@hotwired/turbo-rails"
import "./add_jquery"
import "./controllers"
import * as bootstrap from "bootstrap"

import "bootstrap-datepicker"
import Chart from 'chart.js/auto';

import {TreemapController, TreemapElement} from 'chartjs-chart-treemap';

Chart.register(TreemapController, TreemapElement);

window.chart = Chart

$(function(){
  console.log("bootstrap-datepicker")
  $('.datepicker').datepicker();
});

$(function(){
  $(document).on('select2:open', () => {
    document.querySelector('.select2-search__field').focus();
  })
});

function titilize(str, resize_str){
  if(resize_str){
    str = str.length > 15 ? (str.substring(0, 15) + "...") : str ;
  }
  return str.toLowerCase().replace(/(^|\s)\S/g, function(t) { return t.toUpperCase() });
}

printPdf = function (url) {
  var iframe = this._printIframe;
  if (!this._printIframe) {
    iframe = this._printIframe = document.createElement('iframe');
    document.body.appendChild(iframe);
    iframe.style.display = 'none';
    iframe.onload = function() {
      setTimeout(function() {
            var loader = document.getElementById('loader');
        loader.style.display = 'none';
        iframe.focus();
        iframe.contentWindow.print();
      }, 1);
    };
  }
  iframe.src = url;
}

const indianCurrencyFormat = new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 2 });

convertNumberToIndianCurrency = function (inputNumber, currencyValue = false)
{
  num = indianCurrencyFormat.format(inputNumber)
}

const indianNumberFormat = new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 2 });

convertNumberToIndianFormat = function (inputNumber)
{
  negativeNumber = (inputNumber < 0)
  num = indianNumberFormat.format(inputNumber)
  if(negativeNumber)
    return "-" + num.slice(2)
  else
    return num.slice(1)
}

const indianWholeNumberFormat = new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 });

convertNumberToIndianInteger = function (inputNumber)
{
  negativeNumber = (inputNumber < 0)
  num = indianWholeNumberFormat.format(inputNumber)
  if(negativeNumber)
    return "-" + num.slice(2)
  else
    return num.slice(1)
}

removeCommas = function(inputNumber){
  inputNumber = (typeof(inputNumber) != 'string') ? inputNumber.toString() : inputNumber
  return inputNumber.replace(/,/g, '')
}