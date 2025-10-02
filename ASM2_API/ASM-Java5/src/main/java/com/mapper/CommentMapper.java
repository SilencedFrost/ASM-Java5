package com.mapper;

import com.dto.CommentDTO;
import com.dto.InboundCommentDTO;
import com.dto.OutboundCommentDTO;
import com.entity.Comment;
import com.entity.Product;
import com.entity.User;

import java.util.ArrayList;
import java.util.List;

public class CommentMapper {

    public static CommentDTO toDTO(Comment comment) {
        if (comment == null) {
            return null;
        }
        return new OutboundCommentDTO(
                comment.getCommentId(),
                comment.getUser().getUserId(),
                comment.getProduct().getProductId(),
                comment.getCommentDate(),
                comment.getCommentContent()
        );
    }

    public static Comment toEntity(InboundCommentDTO commentDTO, User user, Product product) {
        if (commentDTO == null) {
            return null;
        }

        return new Comment(
                user,
                product,
                commentDTO.getCommentContent()
        );
    }

    public static List<CommentDTO> toDTOList(List<Comment> entityList) {
        List<CommentDTO> dtoList = new ArrayList<>();
        for (Comment comment : entityList) {
            dtoList.add(CommentMapper.toDTO(comment));
        }
        return dtoList;
    }
}
