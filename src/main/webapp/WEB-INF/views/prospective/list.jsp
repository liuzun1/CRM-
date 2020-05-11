﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>

<section id="prospectiveTablePanel" class="">
	<!-- 潜在客户列表 -->
	<div class="row">
		<article class="col-md-12">
			<div class="widget " >
				<div>
					<div class="widget-body-toolbar">
						<button class="add-prospective-btn btn btn-primary pull-left" type="button">
							<i class="fa fa-plus"></i> 新增
						</button>
						<input class="form-control list-search" name="name" id="name" placeholder="潜在客户姓名" type="text">
						<button class="search-prospective-btn btn btn-success" type="button">
							<i class="fa fa-search"></i>
						</button>
						<button class="reset-prospective-btn btn btn-default" type="button">
							<i class="fa fa-mail-reply"></i>
						</button>
					</div>
					<div class="widget-body no-padding">
						<table id="prospectiveTable" class="table table-striped table-hover">
							<thead>
								<tr>
									<th>潜在客户编号</th>
									<th>姓名</th>
									<th>手机</th>
									<th>公司</th>
									<th>邮箱</th>
									<th>负责人</th>
									<th>状态</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</article>
	</div>
</section>

<script type="text/javascript">
    var prospectiveTable;
    var $prospectiveTablePanel;
    $(function() {
        // 定义数据列
        var columnData = [ {
            "data" : "code"
        }, {
            "data" : "name"
        }, {
            "data" : "mobile"
        }, {
            "data" : "company"
        }, {
            "data" : "email"
        }, {
            "data" : "user.name"
        }, {
            "data" : "status.name"
        }, {
            "data" : ""
        }, ];
        // 显示列数
        var columnNumber = columnData.length - 1;
        // 初始化表格信息
        prospectiveTable = $qingshixun.dataTable($('#prospectiveTable'), {
            "ajax" : {
                "url" : "prospective/list/data",
                "type" : "POST"
            },
            "columns" : columnData,
            "columnDefs" : [ {
                "data" : null,
                "defaultContent" : "<button type='button' title='修改' class='btn btn-primary btn-xs edit'>" + "<i class='fa fa-pencil'></i>" + "</button>" + "&nbsp;&nbsp;" + "<button type='button' title='删除' class='btn btn-danger btn-xs delete'>" + "<i class='fa fa-trash-o'></i>" + "</button>",
                orderable : false, // 禁止排序
                targets : [ columnNumber ]
            //指定的列
            } ],
            "createdRow" : function(row, data, index) {

            },
            rowCallback : function(row, data) {
                // 编辑操作
                $('td', row).last().find(".edit").click(function() {
                    editProspective(data.id);
                });

                // 删除操作
                $('td', row).last().find(".delete").click(function() {
                    deleteProspective(data.id);
                });
            },
            "fnDrawCallback" : function(row) {

            },
            "fnServerParams" : function(aoData) {
                aoData.columnNumber = columnNumber;
                aoData.name = $("#name").val();
            }
        });

        $prospectiveTablePanel = $("#prospectiveTablePanel");

        // 初始化新增按钮
        $prospectiveTablePanel.find('.add-prospective-btn').click(function() {
            loadContent("prospective/form/0");
        });

        // 初始化查询按钮
        $prospectiveTablePanel.find('.search-prospective-btn').click(function() {
            prospectiveTable.ajax.reload();
        });

        // 初始化重置按钮
        $prospectiveTablePanel.find('.reset-prospective-btn').click(function() {
            $("#name").val("");
            prospectiveTable.ajax.reload();
        });
    });

    // 编辑营销活动
    function editProspective(prospectiveId) {
        loadContent("prospective/form/" + prospectiveId);
    }

    // 删除营销活动
    function deleteProspective(prospectiveId) {
        $.confirm({
            title : false,
            content : '是否确认删除该营销活动？',
            confirmButton : '确认',
            cancelButton : '取消',
            confirm : function() {
                // 执行删除
                $.ajax({
                    type : "post",
                    async : false,
                    url : 'prospective/delete/' + prospectiveId,
                    data : {

                    },
                    dataType : "json",
                    success : function(result) {
                        // 如果返回的状态是-1表示该删除删除的时候被引用
                        if (result.status == 3) {
                            toastr.error('该潜在客户已被引用,不能删除！');
                            return;
                        }
                        prospectiveTable.ajax.reload();
                        toastr.success('营销活动删除成功！');
                    }
                });
            },
            cancel : function() {

            }
        });
    }
</script>



