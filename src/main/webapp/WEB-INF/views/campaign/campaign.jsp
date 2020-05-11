﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>

<!-- 营销活动头信息 -->
<div class="modal-header">
	<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	<h4 class="modal-title" id="myModalLabel">选择营销活动</h4>
</div>

<!-- 营销活动列表 -->
<div>
	<table id="selectCampaignTable" class="table table-striped table-hover">
		<thead>
			<tr>
				<th>请选择</th>
				<th>营销活动名称</th>
				<th>营销活动类型</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
</div>

<div id="selectCampOperate" class="modal-footer">
	<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
	<button type="button" class="campaign-select-save btn btn-primary">确定</button>
</div>

<script type="text/javascript">
    var $selectCampaignTable;
    $(function() {
        // 定义数据列
        var columnData = [ {
            "data" : "id"
        }, {
            "data" : "name"
        }, {
            "data" : "type.name"
        } ];
        // 显示列数
        var columnNumber = columnData.length - 1;
        // 初始化营销活动列表
        $selectCampaignTable = $qingshixun.dataTable($('#selectCampaignTable'), {
            "bDestroy" : true,
            "lengthMenu" : [ [ 5 ], [ 5 ] ],
            "ajax" : {
                "url" : "campaign/list/select",
                "type" : "POST"
            },
            "columns" : columnData,
            "columnDefs" : [ {
                orderable : false, // 禁止排序
                targets : [ 0 ]
            } ],
            "createdRow" : function(row, data, index) {
                $('td', row).eq(0).html("<input type='radio' name='campaign' value=" + data.id + ">");
            },
            rowCallback : function(row, data) {

            },
            "fnDrawCallback" : function(row) {

            },
            "fnServerParams" : function(aoData) {
                aoData.columnNumber = columnNumber;
            }
        });

        // 设置
        $("#selectCampOperate").find('.campaign-select-save').click(function() {
            selectCampaign();
        });
    });

    // 保存勾选的营销活动信息
    function selectCampaign() {
        var campaignId = $('input:radio[name=campaign]:checked').val();
        // 如果没有选择营销活动
        if (undefined == campaignId) {
            toastr.error('最少选择一条数据！');
            return;
        }
        $.ajax({
            type : "post",
            async : false,
            url : 'campaign/getSelectedCampaign/' + campaignId,
            data : {

            },
            dataType : "json",
            success : function(result) {
                // 关闭弹出层
                $("#selectCampaignModal").modal("hide");
                // 如果返回结果不是null加载选择营销活动
                if (null != result) {
                    setSelectedCampaign(result.data.id, result.data.name);
                } else {
                    toastr.error('获取营销活动信息失败！');
                }
            }
        });
    }
</script>



