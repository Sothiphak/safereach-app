import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  Query,
  UseGuards,
  Dependencies,
} from '@nestjs/common';

import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { buildValidationPipe } from '../../common/pipes/dto-validation.pipe';
import {
  CreateBranchDto,
  BranchQueryDto,
  UpdateBranchDto,
} from './branches.dto';
import { BranchesService } from './branches.service';

@Controller('branches')
@Dependencies(BranchesService)
export class BranchesController {
  constructor(branchesService) {
    this.branchesService = branchesService;
  }

  @Get()
  findAll(@Query(buildValidationPipe(BranchQueryDto)) query) {
    return this.branchesService.findAll(query);
  }

  @Get(':id')
  findOne(@Param('id') id) {
    return this.branchesService.findOne(id);
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body(buildValidationPipe(CreateBranchDto)) payload) {
    return this.branchesService.create(payload);
  }

  @UseGuards(JwtAuthGuard)
  @Put(':id')
  update(@Param('id') id, @Body(buildValidationPipe(UpdateBranchDto)) payload) {
    return this.branchesService.update(id, payload);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  remove(@Param('id') id) {
    return this.branchesService.remove(id);
  }
}
