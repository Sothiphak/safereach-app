import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  UseGuards,
  Dependencies,
} from '@nestjs/common';

import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { buildValidationPipe } from '../../common/pipes/dto-validation.pipe';
import { CreateTipDto } from './tips.dto';
import { TipsService } from './tips.service';

@Controller('tips')
@Dependencies(TipsService)
export class TipsController {
  constructor(tipsService) {
    this.tipsService = tipsService;
  }

  @Get()
  findAll() {
    return this.tipsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id) {
    return this.tipsService.findOne(id);
  }

  @Post()
  @UseGuards(JwtAuthGuard)
  create(@Body(buildValidationPipe(CreateTipDto)) payload) {
    return this.tipsService.create(payload);
  }
}
