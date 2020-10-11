/*
function clickCloseDialog(){

}
function onDestroyModalClick(){
  console.log("onDestroyModalClick()")
  let modal = document.querySelector(".js-modal.modal");

  modal.classList.add("is-active");
  modal.querySelector(".modal-background,button.delete").addEventListener('click', function(e){
    console.log('click', e)
    modal.classList.remove("is-active");
  }, false)
}
*/


$(document).ready(()=>{
  const target_name = "#nextbbs_board_destroy";
  $(`${target_name}-action`).on('click', ()=>{
    $(`${target_name}-modal.modal`).toggleClass('is-active');
  });

  $(`${target_name}-modal.modal`).children(".modal-background,.button-delete,.button-cancel").on('click', (e)=>{
    $(`${target_name}-modal.modal`).toggleClass('is-active');
  });

  $("a[data-remote]").on("ajax:success", (event) => {
    alert("この掲示板を削除しました")
  })
});
