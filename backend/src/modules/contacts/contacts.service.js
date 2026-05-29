import { Injectable, NotFoundException, Dependencies } from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { PersonalContact } from './contact.entity';

@Injectable()
@Dependencies(getRepositoryToken(PersonalContact))
export class ContactsService {
  constructor(contactsRepository) {
    this.contactsRepository = contactsRepository;
  }

  async findAll(userId) {
    return this.contactsRepository.find({ where: { userId } });
  }

  async findOne(id, userId) {
    const contact = await this.contactsRepository.findOne({ where: { id, userId } });
    if (!contact) {
      throw new NotFoundException('Personal contact not found.');
    }
    return contact;
  }

  async create(userId, payload) {
    const contact = this.contactsRepository.create({ ...payload, userId });
    return this.contactsRepository.save(contact);
  }

  async update(id, userId, payload) {
    const contact = await this.findOne(id, userId);
    Object.assign(contact, payload);
    return this.contactsRepository.save(contact);
  }

  async remove(id, userId) {
    const contact = await this.findOne(id, userId);
    await this.contactsRepository.remove(contact);
    return { success: true };
  }
}
