define([
  "text!./dictionary.html",
  "css!../../style/common.css",
  "css!./dictionary.css",
  "../../config/sys_const.js",
  "../../utils/utils.js",
  "../../utils/ajax.js",
  "../../utils/tips.js",
  "./viewModel.js"
], function (html) {
  var ctx, listRowUrl, saveRowUrl, delRowUrl, element;
  function init(element, cookie) {
    element = element;
    $(element).html(html);
    ctx = cookie.appCtx + "/example_dictionary";
    listRowUrl = ctx + "/list"; //列表查询URL
    saveRowUrl = ctx + "/save"; //新增和修改URL， 有id为修改 无id为新增
    delRowUrl = ctx + "/delete"; //刪除URL
    viewModel.event.pageinit(element);
  }
  viewModel.event = {
    //初始化
    pageinit: function (element) {
      viewModel.app = u.createApp({
        el: element,
        model: viewModel
      });
      //分页初始化
      var paginationDiv = $(element).find("#pagination")[0];
      viewModel.event.comps = new u.pagination({
        el: paginationDiv,
        jumppage: true
      });
      viewModel.event.comps.update({
        pageSize: 5
      }); //默认每页显示5条数据
      viewModel.event.initGridDataList();
      viewModel.event.pageChange();
      viewModel.event.sizeChange();
    },
    // 分页
    pageChange: function () {
      viewModel.event.comps.on("pageChange", function (pageIndex) {
        viewModel.draw = pageIndex + 1;
        viewModel.event.initGridDataList();
      });
    },
    // 当前页显示数量变更
    sizeChange: function (size) {
      viewModel.event.comps.on("sizeChange", function (arg) {
        viewModel.pageSize = parseInt(arg);
        viewModel.draw = 1;
        viewModel.event.initGridDataList();
      });
    },

    // 初始化gird数据
    initGridDataList: function () {
      var jsonData = {
        pageIndex: viewModel.draw - 1,
        pageSize: viewModel.pageSize,
        sortField: "create_time",
        sortDirection: "desc"
      };
      var searchinfo = viewModel.gridData.params;
      for (var key in searchinfo) {
        if (searchinfo[key] && searchinfo[key] != null) {
          jsonData[key] = encodeURI(removeSpace(searchinfo[key]));
        }
      }
      $ajax(
        listRowUrl,
        jsonData,
        function (res) {
          if ((res && res.success == "success", res.detailMsg.data)) {
            var totalCount = res.detailMsg.data.totalElements;
            var totalPage = res.detailMsg.data.totalPages;
            viewModel.event.comps.update({
              totalPages: totalPage,
              pageSize: viewModel.pageSize,
              currentPage: viewModel.draw,
              totalCount: totalCount
            });
            viewModel.event.clearDt(viewModel.gridData);
            viewModel.gridData.setSimpleData(res.detailMsg.data.content, {
              unSelect: true
            });
          }
        },
        function () {
          u.messageDialog(errTips);
        },
        "get"
      );
    },

    // 新增按钮
    btnAddClicked: function (rowId, s, e) {
      var self = this;
      viewModel.rowId = rowId;
      if (rowId && rowId != -1) {
        var datatableRow = viewModel.gridData.getRowByRowId(rowId);
        //修改操作
        var currentData = datatableRow.getSimpleData();
        viewModel.formData.setSimpleData(currentData);
      } else {
        //添加操作
        viewModel.formData.removeAllRows();
        viewModel.formData.createEmptyRow();
      }
      //显示模态框，如果模态框不存在创建模态框，存在则直接显示
      if (!viewModel.dialog) {
        viewModel.dialog = u.dialog({
          id: "formDialg",
          content: "#dialogContent",
          hasCloseMenu: true,
          width: "800px",
          height: "360px"
        });
      } else {
        viewModel.dialog.show();
      }
      u.stopviewModel.event(e);
    },

    //save按钮
    saveClick: function () {
      if (!viewModel.app.compsValidate($(element).find("#dialogContent")[0])) {
        u.messageDialog(mustTips);
        return;
      }
      viewModel.event.addNewData();
      viewModel.dialog.close();
    },

    //新增数据
    addNewData: function () {
      var data = viewModel.formData.getSimpleData()[0];
      for (var key in data) {
        if (key === "operate") {
          delete data.operate;
        }
      }
      var jsonData = viewModel.event.genDataList(data);
      $ajax(
        saveRowUrl,
        JSON.stringify(jsonData),
        function (res) {
          if (res && res.success == "success") {
            viewModel.event.initGridDataList();
          } else {
            u.messageDialog({
              msg: res.message,
              title: "请求错误",
              btnText: "确定"
            });
          }
        },
        function (params) {
          u.messageDialog(errTips);
        }
      );
    },

    // 取消按钮
    cancelClick: function () {
      viewModel.dialog.close();
    },

    //清除 datatable的数据
    clearDt: function (dt) {
      dt.clear();
    },


    // 搜索
    search: function () {
      viewModel.gridData.clear();
      var queryData = {};
      $(".u-container-fluid")//注意这里需要用整个Search区域的来找
        .find("input")
        .each(function () {
          queryData[this.name] = removeSpace(this.value);
        });
      viewModel.gridData.addParams(queryData);
      viewModel.event.initGridDataList();
    },
    // 清除搜索
    cleanSearch: function () {
      $(".u-container-fluid")
        .find("input")
        .val("");
    },
    // 真正删除数据
    del: function (data) {
      var arr = [];
      for (var i = 0; i < data.length; i++) {
        arr.push({
          id: data[i].id
        });
      }
      $ajax(
        delRowUrl,
        JSON.stringify(arr),
        function (res) {
          if (res && res.success == "success") {
            viewModel.event.initGridDataList();
          } else {
            var msg = "";
            for (var key in res.detailMsg) {
              msg += res.detailMsg[key] + "<br/>";
            }
            u.messageDialog({
              msg: msg,
              title: "请求错误",
              btnText: "确定"
            });
          }
        },
        function (params) {
          u.messageDialog(errTips);
        }
      );
    },
    // 批量删除
    delRows: function (data) {
      let num = viewModel.gridData.selectedIndices();
      if (num.length > 1) {
        // 获取所有选中的数据
        var seldatas = viewModel.gridData.getSimpleData({
          type: "select"
        });
        viewModel.event.del(seldatas);
      }
    },
    // 删除单行
    delRow: function (data, index) {
      u.confirmDialog({
        msg:
          '<div class="pull-left col-padding u-msg-content-center" >' +
          '<i class="fa fa-exclamation-triangle margin-r-5 fa-3x red del-icon" style="vertical-align:middle"></i>确认删除这些数据吗？</div>',
        title: "",
        onOk: function () {
          var seldatas = viewModel.gridData.getSimpleData({
            type: "select"
          });
          viewModel.event.del(seldatas);
        }
      });
    },

    //选中列表行数据,【多条】行数删除是否可用
    selectRow: function () {
      let num = viewModel.gridData.selectedIndices();
      if (num.length > 1) {
        $("#user-action-del")
          .attr("disabled", false)
          .removeClass("disable");
      } else {
        $("#user-action-del")
          .attr("disabled", true)
          .addClass("disable");
      }
    },

    //列表行悬停
    rowHoverHandel: function (obj) {
      $(".editTable").hide();
      let num = obj["rowIndex"];
      let a = $("#gridData_content_tbody").find("tr")[num];
      let ele = a.getElementsByClassName("editTable");
      ele[0].style.display = "block";
    },

    //鼠标离开事件
    mouseoutFunc: function () {
      $(".editTable").hide();
    },

    //code转name
    renderName: function (obj) {
      if (obj["value"] && obj["value"].length > 0) {
        var dataTableRowId = obj.row.value["$_#_@_id"];
        obj.element.innerHTML = "<div>" + obj["value"] + "</div>";
        ko.applyBindings(viewModel, obj.element);
      }
    },


    //组装list
    genDataList: function (data) {
      var datalist = [];
      datalist.push(data);
      return datalist;
    },
    //grid绑定事件
    optFun: function (obj) {
      var dataTableRowId = obj.row.value["$_#_@_id"];
      var delfun =
        "data-bind=click:viewModel.event.delRow.bind($data," + dataTableRowId + ")";
      var editfun =
        "data-bind=click:viewModel.event.btnAddClicked.bind($data," +
        dataTableRowId +
        ")";
      obj.element.innerHTML =
        '<div class="editTable" style="display:none;"><button class="u-button u-button-border" title="修改"' +
        editfun +
        ">修改</button>" +
        '<button class="u-button u-button-border" title="删除" ' +
        delfun +
        ">删除</button></div>";
      ko.applyBindings(viewModel, obj.element);
    }
  };
  return {
    template: html,
    init: init
  };
});
