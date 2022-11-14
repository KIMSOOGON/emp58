<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- partial jsp 페이지 사용할 코드 -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<div class="container mt-3 p-3 bg-secondary text-center rounded">
	<a class="btn btn-dark text-light" href="<%=request.getContextPath()%>/index.jsp">홈으로</a>
	<a class="btn btn-dark text-light" href="<%=request.getContextPath()%>/dept/deptList.jsp">부서관리</a>
	<a class="btn btn-dark text-light" href="<%=request.getContextPath()%>/emp/empList.jsp">사원관리</a>
	<a class="btn btn-dark text-light" href="<%=request.getContextPath()%>/board/boardList.jsp">게시판관리</a>
	<a class="btn btn-dark text-light" href="<%=request.getContextPath()%>/salary/salaryList1.jsp">급여관리</a>
</div>