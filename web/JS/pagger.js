/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

function pagger(id, pageindex, totalpage, gap, baseUrl)
{
    var container = document.getElementById(id);
    if (!container || totalpage <= 1) {
        if (container)
            container.innerHTML = '';
        return;
    }
    pageindex = parseInt(pageindex);
    totalpage = parseInt(totalpage);
    var content = '';
    if (pageindex > gap + 1)
        content += '<a href="' + baseUrl + 'page=1">First</a>';
    for (var i = pageindex - gap; i < pageindex; i++) {
        if (i > 0)
            content += '<a href="' + baseUrl + 'page=' + i + '">' + i + '</a>';
    }
    content += '<span>' + pageindex + '</span>';
    for (var i = pageindex + 1; i <= pageindex + gap; i++) {
        if (i <= totalpage)
            content += '<a href="' + baseUrl + 'page=' + i + '">' + i + '</a>';
    }
    if (pageindex < totalpage - gap)
        content += '<a href="' + baseUrl + 'page=' + totalpage + '">Last</a>';
    container.innerHTML = content; 
}
