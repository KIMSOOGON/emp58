<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h2 class="container text-center">부서 추가</h2>
	<form action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp">
		<br>
		<table class="table table-hover">
			<tr>
				<th>부서번호</th>
				<td><input type="text" name="deptNo"></td>
			</tr>
			<tr>
				<th>부서이름</th>
				<td><input type="text" name="deptName"></td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="submit">ADD</button>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>