import { Body, Controller, Delete, Get, Param, Post, Put, Query, UseGuards, Dependencies } from '@nestjs/common';

import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { buildValidationPipe } from '../../common/pipes/dto-validation.pipe';
import { CreateServiceDto, ServiceQueryDto, UpdateServiceDto } from './services.dto';
import { ServicesService } from './services.service';

@Controller('services')
@Dependencies(ServicesService)
export class ServicesController {
  constructor(servicesService) {
    this.servicesService = servicesService;
  }

  @Get()
  findAll(@Query(buildValidationPipe(ServiceQueryDto)) query) {
    return this.servicesService.findAll(query);
  }

  @Get(':id')
  findOne(@Param('id') id) {
    return this.servicesService.findOne(id);
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body(buildValidationPipe(CreateServiceDto)) payload) {
    return this.servicesService.create(payload);
  }

  @UseGuards(JwtAuthGuard)
  @Put(':id')
  update(@Param('id') id, @Body(buildValidationPipe(UpdateServiceDto)) payload) {
    return this.servicesService.update(id, payload);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  remove(@Param('id') id) {
    return this.servicesService.remove(id);
  }
}
