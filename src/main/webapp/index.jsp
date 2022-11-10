<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>index</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<style>
		#head{
			height: 150px;
			font-size: 70px;
		}
	</style>
</head>
<body style="background-color:rgb(20,20,25)">
	<h1 class="container mt-3 p-3 text-center text-light" id="head">INDEX</h1>
	<ol class="text-center">
		<li><a class="btn btn-outline-warning" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서 관리</a></li>
		<br>
		<li><a class="btn btn-outline-warning" href="<%=request.getContextPath()%>/emp/empList.jsp">사원 관리</a></li>
		<br>
		<li><a class="btn btn-outline-warning" href="<%=request.getContextPath()%>/board/boardList.jsp">게시판 관리</a></li>
	</ol>
</body>
</html>