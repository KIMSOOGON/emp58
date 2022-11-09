<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>insertDeptForm</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		table,th,tr,td{
			border:1px solid grey;
		}
	</style>
</head>
<body style="background-color:rgb(246,243,230)">
	<!-- 메뉴 partial jsp 구성 -->
	<div>
		<jsp:include page="../inc/menu.jsp"></jsp:include>
	</div>
	<h2 class="container mt-3 p-3 text-center bg-light rounded">부서 추가</h2>
	<form action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
		<br>
		<table class="table table-hover table-bordered text-center" style="background-color:rgb(215,235,225)">
			<tr>
				<th>1) 부서번호</th>
				<td><input type="text" name="deptNo"></td>
			</tr>
			<tr>
				<th>2) 부서이름</th>
				<td><input type="text" name="deptName"></td>
			</tr>
			<tr>
				<td colspan="2" class="text-center">
					<button type="submit" class="btn btn-outline-danger">ADD</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>