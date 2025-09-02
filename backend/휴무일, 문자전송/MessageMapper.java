package com.gym.mapper;

import com.gym.domain.message.Message;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MessageMapper {
    // DB 저장은 아직 사용 안 함, 필요시 기능 확장 가능
    Long insertMessage(Message message);
}
