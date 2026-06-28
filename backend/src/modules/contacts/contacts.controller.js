import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  Put,
  UseGuards,
  Dependencies,
} from '@nestjs/common';

import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { buildValidationPipe } from '../../common/pipes/dto-validation.pipe';
import { CreateContactDto, UpdateContactDto } from './contacts.dto';
import { ContactsService } from './contacts.service';

@UseGuards(JwtAuthGuard)
@Controller('contacts')
@Dependencies(ContactsService)
export class ContactsController {
  constructor(contactsService) {
    this.contactsService = contactsService;
  }

  @Get()
  findAll(@CurrentUser() user) {
    return this.contactsService.findAll(user.id);
  }

  @Get(':id')
  findOne(@CurrentUser() user, @Param('id') id) {
    return this.contactsService.findOne(id, user.id);
  }

  @Post()
  create(
    @CurrentUser() user,
    @Body(buildValidationPipe(CreateContactDto)) payload,
  ) {
    return this.contactsService.create(user.id, payload);
  }

  @Put(':id')
  update(
    @CurrentUser() user,
    @Param('id') id,
    @Body(buildValidationPipe(UpdateContactDto)) payload,
  ) {
    return this.contactsService.update(id, user.id, payload);
  }

  @Delete(':id')
  remove(@CurrentUser() user, @Param('id') id) {
    return this.contactsService.remove(id, user.id);
  }
}
