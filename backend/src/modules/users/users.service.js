import {
  ConflictException,
  Injectable,
  UnauthorizedException,
  Dependencies,
} from '@nestjs/common';
import { getRepositoryToken } from '@nestjs/typeorm';
import bcrypt from 'bcrypt';
import { Repository } from 'typeorm';

import { User } from './user.entity';

@Injectable()
@Dependencies(getRepositoryToken(User))
export class UsersService {
  constructor(usersRepository) {
    this.usersRepository = usersRepository;
  }

  async create({ email, password }) {
    const existing = await this.usersRepository.findOne({ where: { email } });
    if (existing) {
      throw new ConflictException('Email is already registered.');
    }
    const passwordHash = await bcrypt.hash(password, 10);
    const user = this.usersRepository.create({ email, passwordHash });
    return this.usersRepository.save(user);
  }

  async findByEmail(email) {
    return this.usersRepository.findOne({ where: { email } });
  }

  async findById(id) {
    return this.usersRepository.findOne({ where: { id } });
  }

  async validateUser(email, password) {
    const user = await this.findByEmail(email);
    if (!user) {
      throw new UnauthorizedException('Invalid credentials.');
    }
    const matches = await bcrypt.compare(password, user.passwordHash);
    if (!matches) {
      throw new UnauthorizedException('Invalid credentials.');
    }
    return user;
  }

  toSafeUser(user) {
    if (!user) {
      return null;
    }
    const { passwordHash, ...safe } = user;
    return safe;
  }
}
